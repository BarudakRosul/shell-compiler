#!/bin/bash
#
# Author: RFHackers (Rafa Fazri)
# GitHub: https://github.com/RFHackers
#
# shell-compiler: compressor for Unix executables with openssl enc.
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
]   �������� �BF=�j�g�z��"�gV�>�5I�����ޗ��!��3K�!be0}��]R�DDU�����m�]O����W���&<�/A�}��gV}�����&:W_}o�����=5PX� !������x*1�&t6�F�N쁸��e?��*XTy�p>�a}3��irS��mfL�L�1�=��d��X�{���Y�8$�1�t҆ �%"������I�
�"�/(��(�L�_B���e�h��tz�|�+U
�p1�b�?���>��!!(7l8�|�0��In�a�����J�<;��C�ڽ|�b���ϊ���7�(�e�w�|ˬg!YX��J"��t0�T���Q�	�F�M¬��"g?�g~R�M�!��#.oc8�2��R3�a20��߮�w��{\k_8�ǛE�B�ܟ�BZ�;5��Wb�n����7�kO1��rK���R�4��ӣ��XL*����=�g���̣YC�\�ۜ��"90����>��g��j�]��ש�x+�\��Ǆ�	�;}�{�|��~�L�ѵ��(|M���'I<ΕRK)T�������}jY��C2a��)ؓOs�J���{D�P��$5;
�ʨ5��!��E��Uo�x��ҷ��4�G�*O\g���`���id��a�>q���ٳ��t��!�����Z�-� �zg��{=U][!���%�+��<oj�wm<a0���<F����`�ܐ�A����(!���cx�J��~�M3��d��?2�Q�(�y�B,,t�/�[��s���F�l���]T	�j�%%O������3�� ����G���vP���dK:BJ�~|�^"ʡ>7v�����c�3�L@�EkJ�n�1��5��ǟ����1س�����X�U��q.�a�i��.۬l��4����-�L�ʡD�s�WΛ���a��$����L���=�PIj��v;׼��F	�L/ȡ�#q���Mn<���!�Klx�Ǉ�8����U$T{y;4�Y�}���f-�(!�l'P�2iD����d�ʤ�`>����9�*a�"C�l�P3�!�Jbb��.�����?�����L'gyE63��v
�zht��.*��fWb�s+,ʺ�1��K�V;�^�J0g?}�������N"�A���x�$�!nxMB� U<����:.�z����6NTA�!`�����d�b
��z�'H l�8��r�Z�Ԑh]gݗ���1��gyz��`�r� �d^�]1ݎ^V�d��B 49�S� t��=�D��829 �j���������Tk��Հ�^3I[�[%���lx���Q���ϐ�+�����R��S���>�&���gپ���7w������ED�1i{r�>шsoOJ�82�<]�&5��;qUp�sf-@n�)Ѕ^J�u'<�1������>�Ȯ�[}�]\,���ƹ� ^����L��"E��0?\���S�:/@-Y�O �����nv5�	B ��5�0@P@�\0q'r4�ZO�@qOI���i-�id�3�0O P꺮�U�4D�%!�U�T�"�O��]������矶k�7i�~Kx�DD�3����b�OtQg��Tچ�E����� X8a?��O[�-����ȪH���cד�(��G�ٯ*����=v��혗����o^�z�=��nɋ�1�c<9vuAs~���~}������#�Ko�T�溜�3��6u��l��	��,��Ԩ�ж��8��Mx��ye�X�ˊ�7��>���[s��GۇA�	�EIQT��8I2�"XRE��Ry�G�$Ċx�0|=w콶x�4�໗�E0 �|ӊ�j�g-�!�f.:@P¡�0��:��5Y��R�lE�p���:�%;��A@ 1�h�Z 0�)�{A@db`�ݳ<k��|S��ά�M|�t��;Y #����b�c��^q���t�!#%[�`�z��k�x�H�19�ƌ�I �ؕIa^\��M�j���O˖��ټz1��o6%�ue�=�����)/����nG}w�:�1��:���N�=�^M�T�|�-�qWe�r�^m׎�$c9(���[�5��j^�8s���6�L��Fy��)��37��|
2�%���cǰ=X����j��F��i���>\�ϡ��ZV�b0wWOa}��Ë~
 `0��"���� �5���PR0�XC�Q
��D����wZ}�؈���K$C��o�u���p# Y��dɺ��S0Z��RRo�q9���'�t��`}"i��m0��#H�>�{1?M�Γ��_�7=L�-/gS�q�R��ce1
U¶��{upt	�� ���_�<&�1t,n[W�!��Hb�0l*dLXΏȧԠll�Z��k�c��D��y3�`_k�"t��'���[fW��L5�h�ga���6/�}�'�^���Uiu�	m�4����௕�4P��0���x$��qL>�����m�xv�&યx���x}�(#��`��ջv�$5Jjx+]7�����6	�U2	�u7 �75�Q_��\��xuѐ�-���+�0ш�#Ta��n8\_��B*dQ����^PZ��l��mї��fn����������_��^@h�vp!t�,7v��d;�L�<�ܞ�����?{��f����\�����Qa0�U�E֘K\�.�L�'B5O����Yl~H+!09�M�N��lV<�Gk��>�b{����%_�z� �!�B&v)���P}�AB+�I��P@�
��qc0pwLvp���+]�	�4�5�i=L�.���1r|�7/�Y�)�欔�[�r,4a;�¯d^��4� ����p�1	H�a$�����Y�0��y3Xg���!����
{٬�E-�P�d7�������[�S�5 �p)k�>�M�ƹ���W��ÃV��t�Iܗ�t�D�̔k��<�s�D�����o�%n:�2Z�br&!<���_q��trG3���D�ۼG�2�/��>���W�@�6�1 *p���s���M���G8��)-[�q����y!;�;$`����>+<RYRf0��ޱ�%a���\,8��.��,]��}���f[7��|��e�24�T��\k��L��3JਊV��c5�������3k�S�=2�X'	��]`�IX'�ի6�R�\���U\��G��b��q�CM[�Vl5���3t�ŨJК�>C��ব	�������
�c�Hu�g�
g ���$�i�|6��HS����c<�Z����[[��o+�q2�Njgڸ@������ԋg������M�˚p囌����TX�SBI���HG|��K0���^��	�[)�� �4d=~�+}�T�:�%�,pƌSr���=��,���/�Wug`'��fR���9��=
"��?$��8jg�=��
���C�C�=�����[�'�V�қy(_j�OR>�if`j$dщ���تHp��8�!e+t.��l.L�tB̙RlUNI'I�(!:?x�C\��l�p����p��ldȺ¦5W|��w�`Y�NBLH%˪�]��s�J<ϬߜY�'��[���ȷ}pC�Z/KE�ߋ�Ǖg<ܵi�=�\i�vr�A{�z��`=������,R ��pD,1� ���EN�&�G����dAo�~/<!hٵ��jC
bD-�0��3����^7�Q
e9���b���YP�ؼS��g�����<dힷs��a�)l�G�*N�������������e,��p 5sAB�y}(�Sk�j��(l��Јm����P���&�A%��(�4��]g�@!����s�"��	� a�y��8S'\�gҮ�1:��d4vvk�j�i���I{���=���:����Bd� 