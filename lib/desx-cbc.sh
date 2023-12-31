#!/bin/bash
#
# Author: Andi-Rahek (Andi Rahek)
# GitHub: https://github.com/Andi-Rahek
#
# shell-compiler: compressor for Shell Unix executables.
# Use this only for binaries that you do not use frequently.
#
# I try invoking the compressed executable with the original name
# (for programs looking at their name).  We also try to retain the original
# file permissions on the compressed file.  For safety reasons, bzsh will
# not create setuid or setgid shell scripts.
#
# WARNING: the first line of this file must be either : or #!/bin/bash
# The : is required for some old versions of csh.
# On Ultrix, /bin/bash is too buggy, change the first line to: #!/bin/bash5
#
skip=77
set -e

tab='	'
nl='
'
IFS=" $tab$nl"

# Make sure important variables exist if not already defined
# $USER is defined by login(1) which is not always executed (e.g. containers)
# POSIX: https://pubs.opengroup.org/onlinepubs/009695299/utilities/id.html
USER=${USER:-$(id -u -n)}
# $HOME is defined at the time of login, but it could be unset. If it is unset,
# a tilde by itself (~) will not be expanded to the current user's home directory.
# POSIX: https://pubs.opengroup.org/onlinepubs/009696899/basedefs/xbd_chap08.html#tag_08_03
HOME="${HOME:-$(getent passwd $USER 2>/dev/null | cut -d: -f6)}"
# macOS does not have getent, but this works even if $HOME is unset
HOME="${HOME:-$(eval echo ~$USER)}"
umask=`umask`
umask 77

lztmpdir=
trap 'res=$?
  test -n "$lztmpdir" && rm -fr "$lztmpdir"
  (exit $res); exit $res
' 0 1 2 3 5 10 13 15

case $TMPDIR in
  / | */tmp/) test -d "$TMPDIR" && test -w "$TMPDIR" && test -x "$TMPDIR" || TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
  */tmp) TMPDIR=$TMPDIR/; test -d "$TMPDIR" && test -w "$TMPDIR" && test -x "$TMPDIR" || TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
  *:* | *) TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
esac
if type mktemp >/dev/null 2>&1; then
  lztmpdir=`mktemp -d "${TMPDIR}lztmpXXXXXXXXX"`
else
  lztmpdir=${TMPDIR}lztmp$$; mkdir $lztmpdir
fi || { (exit 127); exit 127; }

lztmp=$lztmpdir/$0
case $0 in
-* | */*'
') mkdir -p "$lztmp" && rm -r "$lztmp";;
*/*) lztmp=$lztmpdir/`basename "$0"`;;
esac || { (exit 127); exit 127; }

case `printf 'X\n' | tail -n +1 2>/dev/null` in
X) tail_n=-n;;
*) tail_n=;;
esac
if tail $tail_n +$skip <"$0" | lzma -cd > "$lztmp"; then
  umask $umask
  chmod 700 "$lztmp"
  (sleep 5; rm -fr "$lztmpdir") 2>/dev/null &
  "$lztmp" ${1+"$@"}; res=$?
else
  printf >&2 '%s\n' "Cannot decompress ${0##*/}"
  printf >&2 '%s\n' "Report bugs to <barudakrosul22garut@gmail.com>."
  (exit 127); res=127
fi; exit $res
]   �������� �BF=�j�g�z��"�gV�>�5JΨ��L�kȚ�K�=��P,^yo�7�Z$�B��6dp���IԋX%@s�����NO�cH������Tҫ� ��o��>v���� b�T˛�rmC�Ik�AjVʴ�;p۹��<��69��<(H%,��Ȧ�����DkK!�=�9�ӯƾ��L�a�'o?��I�������B��I�bR�%���L=a�v�����MV��)����HhөMb�T������|l���{�	��|�d$�K���]}�u?�ye���#A��`�G�ET������V��ʇg')k��2f� /N8���ӆ16�ӕ$0ٓRԬӋ�n�t�ϑͩO�2:�A4X�f�fj��G+���r}��Mdf�c'�OS�=��� �+�Y�,� �r�4+Y4`�&Uҭ���.��������,p��+3Ht�Xɒ��o�HM8�]�d�$���Q���7�?�7@��r�R���'(�.�b�������ʝ���;H¶�t��#n`~G�ip�#��:MU�)�e���= �Wz-��	�>v�B
f6��݋�(U �*����j�x��=���Hm��}�}"��V.�ЭsT��^֜Ϛ}����U������҅�(]#�\����p�������ϊ�X��9�ڪ�����Fy�0��އG�"�߃zGZ�=���u��[Ef�,�|=d;֓2�n�����,�ڇR�c�{�m�����u	�e{7g��V����w�LT����x���ߥ�u����K�>���z}>Kqw��� hQ���5���o9U]��嵗}�$�Jy�T�0ҳOh%N"T{1r$N�Ң�(�WW�D�әo�]�g�:�D�Kt�)��+�Ki�e����c��d�i| �9|E$cѼ&���d@=��k�:���bY�y��:dX���"@�C�B(�ݵ�y ���ꩼМ[�֣�r�3����ȰaA�����q��_Q����ٺ��M�HS
h?����ί�~e���a��2�zD#��Y���%�-�M}�w'zmq��N��k���x`��#�/uw���Fו��:X�r!q�^�,�.���P����#g�r5�l�!��d�,��J����ox��G����l)�ꌹ���\��2��/��Ꞌ�qj~�$� 4qB�#��n���d
m���4�*�5�nOLP��U�?$�	��>4�B�x�i�?ڊ�P������>C��1`A^��C'��?Iͱ�8[���O`��g��e�.����;�����yLC��-�Su���=�G�q�ӆr�����sEXbɔ��!ZQ~�����wM���a����7;Rk�c�?�"�	B�D�ku������c tc�x�z��X$:Y*����j���y �^ҥ�|�L���������Fp!��~��%�T8�)o�I!����V�$:^�Զ#+㗶�O�'kpy���_3_�0�jG��|7ËSwQY�ڡ�xi.��L�!�������1�!�'8��})*�aKu8f��o�6�@p����U�e��Lc�Q��/T})�u%�N8D��ϚX�yn\��"�(�'�n5:L���]6	J��!f6�4PҡG��|Ό��XDsk�_�����{��Tͳ�f�p�Ц�����UO}��`�~`���^���<�.�)L���0�:�e"�����w%�G����v6��C'��֖�>vp�i�斚���hfɢ����S� ^���v��hE�{���*mɳ�(���Zn�����-�c�C'3 �F��_i,� P�ʇ�?�(�<�fs�ˈ�W2	U��m��X�,�l��r�; �v�6�[P�7��י�a��%��i��X�`r�t- �]�˧�Iz�7^�g
X��]U��^�0�N�^v߼q�h��!��h��l��������,y2���[YBғ��A��6��P���_}a�3V�'�!3!�4>֊ۛ�+�b�nF5b���q��!�;��p��b|Gn�Yy�.��Z�|�vC�k�ѨЯ�/����yG彾�g��w��f@�(�9�T#�+��L�Zϖ����z
���Iز'�W�yZ�X�G��I�؊�Ć40��?nEr�W~#��X����]I����۔�H��� ���%�*����|�9~����A��1c[K��f�$����E8�z�b,�Ӏ�|[d�Ed�g���WZ�'���t�^���2��%�4"Y��`�iT}#9s~IPO�^��ӌ/�V�a�P<�[D)��
H�m�I���c������Y���l�B��6���N���I�j
��� �	g.�A�z}���|��z,�P7(Z ��V�7� �=���$�u�5��U��#��yb��\���b���aX�+�X��F�V�s9\��e�z#�&���#�B�fLh�9h��>^�?޳�&=�h�{������{�9�'�(������ȥ��Ϧw�v�Vܚ�:�����a��N�C�~3`f��Zc�S��m�J����[
.HL�Ҏ���|Zd��?�hJ6z�}E.a����W{�d��W�����cg����ڋ�2�A~�� ���,5�T8J�X�-1vꧡ��w&����_*��FQ��E�%�sd3!�L�Ȥb�#_E�Ż�_.�����nV�E�檖�n���_�}��W����h��f���}*�X�U��o��v<�<��*i�F�ůfp��(���\��\�*�Y!Q�@\�"��k}ij�x��|D��c��@%u�\�j�0t���UQ�Q�X3K�lGnK^� �I���z0��]<j�4j�� �~V
ǿrfХé$,lA":LoVMoƠϩ��U�W��ݧ"Z�����n���݊��4a�0ގj�V��`.PGr�A�
�Y�.g~"��:	�������8�/n�喝���n*���sC���.���}�4� D,��
jR�M�@ˀ59T����w]��ݞ���+(�j�B�m\T7������`�kVH��"��������� �=�*E�y;�Q�6f4�3�oM�D��Qʁ6�X��֋�O�v�~�.��`��Rl<d���`�g�wr��vZ<�PY(�<�c�Up;:�c��8raC�S����,B/��i_"!�����2�J+��Br�$^���i�a>�|~�y z�of��J��f�$�i�I��81"�#.ipo��
��a��V����'0W����:�?��F'�]�%7����d9��i��8�*�/9��.�#��w��H��Oܺ[]dX1�K���b�3��N�gC�Av�� �?+��	�N.�q1��0a�}}A�Y<�"I�7�~~X����)�ٸ*M;��;����}����k�BD������}U4��!b|�2W%��_�{m7Y���S�U�}fZ#o��_��4��*��7�����y@�K =5�!���J���3T��ʋe�sS�7���	cF?�ء�z�"�	�ߐ�
~+�f��dr�aA@�3զ�VCJ��������U�ZT�����'�~k�Ց����s��G>��+��T���ךؗ]�WW/�^����gbO�����,ӕ�4L��A#-t)<^RR�͊	�7%\4r%2��gȖ��F.a�ͮCg�є-@�l�%�pr���=�!t#ː>�T�
�d�S�y5�O��UU�GT�ռ��|��Zp/t9̨4U[/pfWJ�3-}�t^F1\}�ŀ2׺(E�&o���Y" �"���y�H��n��H���Ɉ�=<�&�F�|�qNGC���VD�J����͛*J=��%��_�)ٲSڏM�G�5�hy�B�5�x�.N�&n1��Td����
	,~_����hb�I�R���`�kg�%ە��b*������D�gp��(�K�RCnBJ����`ZL�g�g�9f�M�z��+Yܭޏ��2K'���Z�,jA��Y�4��D��f��Q�7�#�uG�C�ob�т�Y6�;[��GosƉ�>*e�J��U���_Q�Ǉ�愮�;ӕc'���a߻�T�H�+�h௻9�0�(`�1��o��...b����DGb�*A����|*�/ag�U)tAN �{�}#���� a՗1!9�kcm��� m�*V��0��D�YX�K�SR5B�/�76�v��!.Ճs[�e��!0��0�7}g���<�BhJ�G�W5Y�r�T�\���&�-��>�ϓme�JkO�_�r@)#��f��z-����ʜ���l&Q ϸ����6��9~�T��6U�lC���f�~3�6�!
�y)�H�AWҼ�E���?���l�雌6	G�*y���P�k�s��2R{|A�p�;�[���w��fɼ���0#(#$�7�;�� w�_��� ^v������qN��Bĥ"u0��@XbYv�6�*<���O�ga�s��]���xe�F�U�t�d�@�YA@���P\�Qj35�1.|�k�
�I��p;�b
{�t�@�A�Є��	{u)7����,�(g\��� �]ȳ�:�%n~XY�Xx��#^W�u�Ĕ�s9�r������K,�AD����!1���D�'e�J>�;?^��5�$lhn%/nC��n�x�����b�h�z�T�E�2��bi�q�[鏅�`I�|��4.��,ƋJk)V�������'FB>�˰�a�|[`�&C���\�%�t�ӝ�c��:�r���>�<�W*jGK]�6�����
�����a�5������	�,n�����"I�~~'��	g �P,<U�<���8�?!�#D�}�h1��$�Hf���2c�NַtgD{��N<&+r��y����CH�������Q���)��抹a[濭^Y��'�H�jB��ݿN����N��k@�zds�Sn-��	o`�V:�0�8<��n?}�tZ
ɱ
:�+9Ss6��3�ѣjV�6�	���VZ/��Fl/�\�ּ*>V�(�9=���Rl�L�T��P�Ѭ�`�a,`����W�����h�#���Q`�}x���bH��3����0h�^Ixo�~"���,����QE��ؼeܵL������ʾ+�lR:v�.ۺ8���eㅹ,�D�3�撹�|��v	�C�` ¶Uy��3�ܷߗ?PȋV)X�G�D�,CjU�����(���W���=�gS�}�7vSN.���Y~��M�����s1��<�O��Ò���"u���-C ��^����xЉ�o���gY֦���;`��]_Pr�yHE��m�P�wJmK���uU�;A%��;o.���x���T����� T��+e�N0��ұ?�]G�!M�l�TV��$S��}�կ=�����g̖�Q��g�����|^B+��ީ�?Ȯ�
9����,ޣ�7��XH#؃ڌt��� 