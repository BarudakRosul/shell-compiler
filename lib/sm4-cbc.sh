#!/bin/bash
#
# Author: Achixz (Citra Bella Rahayu)
# GitHub: https://github.com/Achixz
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
]   �������� �BF=�j�g�z��"�gV�>�5JΧ�"���*f�A-�˻"��Lϒ��)c_kǂ�ݻ�o�-t���
K�����8Ŭ)�'Ds{.����U=6#�ɢu���һ��%�r����{�l�����7:e1噠 2�U��O�N�(�y.zۏ�B�oɎC�~�ԓ�-����NR�$|���؎#K��(-R*o@�З{H���O�T���ʱ��Σ�,�� �[�����܍����I��ȈUc��ݚ�4W���Wi�������c�Łm��C*�&�v�o"$M�$7���pO5�=��Z�h~�z~=!C�U�d�[㒋ź2D*]�;����׃o�*c�%V�X~�9�_!r�2�O�W +ɻ�l_rⷉ���J�N��W\vg~'l�h�?��`!�4�U�Vyz�l���y1�E����S�ǔ�ږ��f{��bk�+� ���땶4,�(^�|��T�6	8��.&,D�IH}�"�O��X>��1��� ��R���D�;))�ķ&jݷ�D%�:jcSx3F�H��]��7䞮Mʺ/�B�.^}}���2�a�G(%Q�MgP�P�rD�m�������u�����O�L>�ߎ���8�w���r��ۀ��8r�+�q�Z- ��n����0G�o%؝1�h��>*+êYO7�gQo���k�K�18]Wٙ=��6}�b��t�� >W�IQ��n��,d��M$���Ţŭ�&ּb���L�4n���4=�u~�����Α�C��F]�m�q��%p(i��5֩����t��xcY�ׂ�3!.KI2ɑ��\S��e䕃d��yK���9j�/x)hi�Ӷh'�{9� �hΞ�<�y�D��\J7��;��n�=E����e�J�#ʴ7�;+)�o��!IU�����=q������oc6׏CV}�3_��t�ɴ�4�}��ǽ�W���V�Uu��f�-��?����W��M��ӅO�|XC�=1�T�tJXE8��4�r/M�� v����?��2��7��A*�Dm0)��k
����æ���4�Z�7ȫ��&�GJ�.c�[-�M[���x"�퉮�X	���8OT~@����-Cw��%8�6�_m���Og"���K�x1`��gч��Y��?����[���ZNC�ӊ�),J�z�vɏ�n�f��VA�t���'�ڹ1Q\@�~��s��R��>6" �E�6DƳ�$���3�� �!�PLq����=1�U���_t�B�����.?A��|\����+G�>���߿�[��I�kCA�(�.��|�y!��n/�Zm�e���\���4r+b�d9*ړ.R07�DŚ؀�ta\!\��pR; ��Q�I���'��C�7��eݠ�?å0�g.�9�vۍ:Q`wy?F���N�Q�Y�Lq�ß.����H��^�a3�D�"�IMQ�Ƌ�N9�%'�)5�A��+p���xc�;A��@��Z�+�t�:b��{��cj[H[N�=(>����L�ӱ�{�]|����w�o��.a?T��~I<t�A��}Kt�6aN4}�k���IdH�HQt�T���s�g{�x�8��Cc�{x�EA<0�_���=�/�o��ΩU>�a����L�go���ɭFփ��9�p��D�s���R���DA��|�0x�%�=&w��4��c�9Z��ՠ�Š�Zcne�C�)��|����$� ~��q��n[u�!���9%�U�`U(K�]�]���$�z�MX��Z�!<>��
�\��NC R�Jߢ�qTɄ�~oK��&���	�ݙ�8�����	A������q����F��W\b+�����8�)+2 ��(�����U0�%sy�k@�4���0��g�-Q�O*I��Ը��2E�7�8�27nu����l�=����,�}�6<��?P���R."��@�ܖt��T!�(P/d��wk�K"��.-G*E�b����A �ѓI�b=��#'��1�#�Ȑ���=- K��.��ۮl<�JC �gq� hD�թ�ڍ}�9���q	�Dh���!��	#��3����*<țb8+>��%���Nc����S�������,��긾e�a�;�7;"�õ�����\G ��e������é��MgUn��>�G����tl�i�% ���X[m�<����7�/��Ɋ��6��e.�:.�3(Bw�Mk�_-��>�V��=cT��@���TC�O�ȁ_������[��sH�]�-2�1j��0b��cp���ۜͤ3:�Y�\��~#��LJ��������g�*���asC��6�٣v�;^��XxzR����f��M�<8�+��7��2�³C���7穋`���i̛t�1�h�Gxpm)���K�F�ݕu�fm{��+�-�g6����d�(�a �`�n�w!�r���/���r�U]��"j�����x��ﶢI� |&�U�y6���٧ƞĞ>�
Ȳ��V��+M*j\W�v^E5[�������W�R~��8�Q:�vgqbT�y0#]+䦬W��8��ʌ����m�:+}��}˿c��6jV��;�0{�朤C��*�j��q�?�,�]Hb�A�@NvK�[�6Z��.a��{ы�OG�pr�KH�������,���"�I�vt���hG��o���|B,6v��{A~T��x��T���r��Z�h(F�����ҳ=�Rvx_���j֭�b}�X*�9��iPdte"�`,��`��UTE3�%	�
f֟&��rS��kM��0f7Q$���	+��-��Д(昋�Z��?g��=�Z�MG��Y��>&=y�8�����n�&��e2R�+O^�*�i&�R�J���+�)ڔ
��3��#�f�ۡ�o�l'�ܜ�4�q=�7Om���`J�I�n,Q��P�`P��G5�350�
���E�W��2���;.�p�Ȕ��2���:��/U�D q�/�����_��v��C���U��l�O�(�	m��_������ٗm�d��ז��r�M
���31fH1e��|8��.e��ӯ�����X���)ۜ�b����j)��	�V���ܷqڎ�;Q������N�8*���g�b<"�'/�����Y\�-���,�-8���,��B0s�6Z���4O�Q4(vB~����+���^���ˤ�l匿������?��A�{���	:�8�7�j�$7P���	e-CG���ʻ��O�y6��I���xo0�����DI�K��C���hV���6_½��ޟo�`�4Q�� 2�Ϳ��lD�-엤�-��>q���1��/�I7�R�DE:S��NV�~���M*ɀ�5�@ɇ��/\��V�w7����֗�����լ�{.�<��G��ȶt�h��3z�S�RH�yE�B������!͕�XW�'�Yhk�;���n� ���߄~��GM3N�Μg�ˣ�ԲK���zo��R��(ǜ(V�=���
N���@&��չ[38��7rS��gHR�9�Q�"�5����R+E2�AOqzUR�ƯІ��W:�_�)�n�;/�]0Ge�2����B��ʈ�jgn�8�!f�����H@V����J�e�lo9� �W�W'�<�)9�#A{8�ץ���1c���f���?����� �ˑhu���������G���EJɱ"˿4Y�����yC��pG-�Ȋ
W|�
iՁ�����������$S����ԗǯ��>X��z��|jj";u���M��X��s�.q�קu�'p��RCV��J��a"mVY�9.���d�^�g�m��V�<9_�g������!o�E�u��ZM�u$�8�eF�iR�}��b�~�sVY�����т���(��W�1䋹-�z�/��@�H���h�տ`��#��RF��sF����;�J'�@�y�H���{7���`$������c�.��ӵ?As�˺��)G�%f����<h�\�NC�J��6��#�Ov^|��T�nEϢ��K�'�o��<��)m%������ſ��'�(֛�����S�t����T�Q���,^n�JbK�>�	�>��j=���s$-q�W��ڻH?�[4@f�՗7f;
��j˵>l'`�9[Q�o�r�-8 ��bJ��	�Mw�K�v#�7����0��'ʌ�4)��k��9�)�F.zD%�]�w�i����\�_�T�����oک�8�,� �*�r�)&Ҳl�>�S�Y4�(�~��^����:��S�P[�f�`�(�(�д�ϲnț{s��o��'��Ѓ�Ş���q]�ݽ6�0���9~��Φb]��#�0L>��g"YJ"�~�H�[|�mԋ;�������HO%�01�g�v����˸�l;�J����^Gý��Է���k��C"
� ���*$���伞i��)B��K�s���͠�qP��u]Fsҏ�)�>�̞w�II�:G� \$hnً��v>pԄ�>j��&d?͒���ܱ%���M��/�d"M��u�\�J(`�$)��XjC������@��~$�}��~���О���C�T��]7�2sxJm�s��tЃ�ף�׮0�9���N�災�L�t��%&�NT,����f�~X��9��?m�"ڈ��i����w@y���Z�$����pH��q��n�{� 9)�>��A�X�0z@L�N2�~
��:�g�7������q�7���&�����[1nJòH ?D��~�:~*�ښ����k��v��k�C��6IakU�X��/�Y�����D�jd�������ɳ������(��,��5�z�9�=8����=����^(<���?k:݁��܉��:��	��>Ȁ��%�r��`c��J����v���2��.���Wv�l)ub͹mG ���چ�o{1�+	��W�OzVۄ�w���[.E�Ԗ���xÊ2���OP�G��sϙ̂k:NT��*I��7����'�	މ�ȋ� �S���0��o�R�xlJ�ma0�����y$Zg��E���q*-�Dm{�Ѫ��W�}	��
I��.��9a5��A����@��6����%)bES���ځ���J*6ŭ�'��_݉*����oϑs��p�DNw�� �.�{�5뭭-f�=^�Y�B8-�-^�vջ�>8�2��IL�A�����V��fG�ex`�Ig:O&�u��Q̚���}d��7��
���]��3�|��,c,�gڅ�d���:W��_W�G���
��b��EKɚ���/�M�O�Ma?{�H�YߓD��� 6d�K�qXl�����S�C�(��U�����i�#\.ᜍn�IxV��� 6�rfk�&�k[��S�S2���	3ĤP5wn�w��e�x��\�j�/�?�s��ё�f[��4+�k���`a�fy�u��5a؏���>ݶ���_��gK