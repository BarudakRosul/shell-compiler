#!/bin/bash
#
# Author: RFHackers (Rafa Fazri)
# GitHub: https://github.com/RFHackers
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
]   �������� �BF=�j�g�z��"�gV�>�5I�����ޗ��!��3K�!be0}��]R�DDU�����m�]O����W���&<�/A�}��gV}�����&:W_}m�����(��X��,4�cb���Ȝ�g��ʥM�U���\���0��i��p'ǰ��������i2�.O��_��	`hQ�a�|���,
�A#71$�]	�б�'[���	%���^�e22пX4��۶��	wT�A��n�4�N˙�)ӱ�0�qx�fo' �xK�xM}(E�՘>6��WE��֣�[54�a�ҧ��0IR�R��Y�S��GOCZH]�����b�?�O�*�5P��!�ĸ�x�P,[|F�$�Kw��QL��2k����DLk� fv@b�QO�Q�b��(�BY��kQf����hɊ>��}:��Q`��S��_372��ְ�� /| K�VE�4����M��X�˜���;_��`����K�T��I�'��᳂��U@�P1O�8#7(��� �|a9�EXq������8J�v�J����xS�䎍�X�1
ڷ,j<R�|R͔5�����t-i�P�$\{�A77^�ܦW;��0R��iT���;r�J�eD%�K��΍m�{�����F��ཫ���>�Qu&jS[�	fD&��{ET�_�d��d_���BEm#�En���|�h���a�C�������Ba�K��L[uc�TP"Ij�1���V�q<��X�`?NN>e<>$�y�
@ �g�T���Q���5��JB��OҀs(�Nd��wy��i�{��a�jr4�z�!�u�<���`*��M{Jl���]7}%���9o`�@�)Zj�;� �#-��5-9X�([V�t��|�����!$\� Ɋ���E&F	�<v������!���]�3v�eN�����<r��ž��7�
�7�)8��ԧ�r�)*�L�a�/~�K��u���^⯽��v�;{ԂcEYB`_���@_Aj�~����f��k�f����ԭ=G��P��@���[�l�\�E�~�p����6�#s딊^bF*c����l��z�E���6��U�nJ���6����j�]r� ��4�}Ŏ&�]�ɞ��8�(,�mr#R@:�d%�,��gK7�b6��nO�E�x8j����Lb�㶷��P��Z��^��=�1��[*�M��\ʱW��i��2��N��@4x��C\O�!طT<�Q�{��`$:�^�K���~�������}�8�Qi1o
U��Û��+A�Į�ܕ�7U���}��:��'i���&W�!�Ѝ\��,j��2c�'<:Q�J�4�c����u{������x��g�ё��\��<3ܺ?��g�GA��G��� �-rp�/����	�ӢJ�^���j݇׾X� �}���9������!'����N"^1�@�4�'��>�I���g��(4W��9��������_��Ӫ��L�\Je)�nBf�Yb���r���9F����!��9݅������]�u������J���8��,+��N���mE����Qe�]	��/���t�Oi�a����B���*�Yi{�{V*�����ٸ
\��ƴN6V���:ZLky׹��(\W�n���݋�F����;T�T��4nP����\�|x�p�5*�Ӏ�� �NC�4"�g���E��P7���Aa`p �g��J��hH_*f����ko���W�r�Pn����&b0��+J��$��ٿ�N~X�
�
�g�����ܟ��`���"(OG�Τ+�E�~��"A��L�B9DV�jb����C���z�� ��
��Dh��xIM���Q�
�ۜ��� �����}b��� XK�1r�Y
=�D7��sA��9��4U׶x��0�3t��
�L�<V�s�!{����v)��	i�D�u��ˢ2���vC�g���5��C��E&Z G�V�<����ve*BT	t'���z�s�ߖ��.�������ƒ�o����|ZX�㈚�Z'�z̳\��Y!��?A�p���s��@�u*�wF�!�a����U������3�
	�1 }2�>�����8~��N�;
�U��P�ȅaO�z��[�����O�5۟��*#X��[�h�(����d����=2H��a��z�x�����RZ�� ��q�@J����jmn�S
����ƭ]T��m�G]�`����6N��� ������IE�3(a���s���q:�}%��ϗ0,��W�o�	 ����}�^h�mGU���(ڔUЂ\��?��ʜ+}A��ƄH6�W�?Ā��{���Қ��)�X��=LCFp��W��"�܂��5	��"�!b���� �%á	K����p��|����C:]����+�ja�D�4ګ�N�gr흒��쎂���	���]%X�s�"dkph9��_�Χ���
��T~���02ɀ�||���?N/	>��6=A�<���6HIu`�	�5�b�2�ϧ��uk��AO�TRLr�E(^�+���`8]r��}�l���������{,�t�o��+)��F\���yꚺ7 @`��waT�(KilS��,0�	�UѲc�i*�D��z,��͎��_�
�/��v��ft4�ٹn/ ��n��V��h�ݲ��mB.�,`W(�'����1�J�}���#���}"ሗ4	Ut��u'"��ig2>�5x�*��]��m�Y.�X��O�h�V�P�� �&P����ޠ	 o!�ss�@ܾ��^
r��b=5J�t>�����)�b�tȍ���	)*��2.T����j�Q`2�H���qR�pbw���%�
���PΌ���3��7�Kb��U�N����ϴ�q�4Ôߣ[��e5��oO��4@�&a=�Zٚ�(�UXQz��.���#�x�m?�Ɩ�c����Ѥ�$�C-�,�@�l.3��ۢi�,'���j���o����1����Z5�ς���HbI�ߩ��r��Ge�X������+*�DC�-���уz�E���Z��m��C�vt�L����Eu��.�7�!�I���z�Ih��2��.F�%�G�ɔ�շ}���C�z��0�>�"�+�O�2��m
WA�3�oⲣ8�7ȵ��r���e?�F̫_��b�,`'0eGb�Y����}��P������� ;!R�V�RB����?=W2���8�)��0���\�b�\�ܡM7̰z8!� �is�)��p�b��e�j�$[* ���˶�yz�Gⅺ��z����� �M�h�x&��:��kQ:��d̥M�w酪���\x�ڜC%��ء�'�g9��ˬ�E���{��;J]�k6��H&/��s�%�y*�����ը.�$�ƍ3��i{�����V3T�v��ivH�R,[�{�Y�?�n֒�Ű���wa5h(j�������U�=�})�銱(9�-,���¼�B-��eP��=q嶗e^����3Z����:��g�M$v�2���E���:n%fI;�5ݨ��AT%�]9��=%��v�&	�q����}���4עT
�''Bn�&ۈ��β�4["1L����^���F!3涓P�$2�r@�
8GO�<�Hdj%w���� ����c�&����l����tn;��J��w�$���?�=���0vlc������ܠn>��ʺ/�^o�+�#,�d�i�h=3)7�
,~�>\.��R���*�:�*8���f?z4��!N
��}�w��*�WQ�Y���Ŗ*D�ʘ-���})����9��(�VtV{;�7Q����c��jUG� �M��9v��������t4}����'\J'졟�LO��'�D:a���N���J��.�9����F)X���� =�r4��ҚD�;�;=����u�[�2�D���	I��1��.Y%E�@5����Z��U��6�"5��p<r�)���n�Jy!|��F��߯�ȶ��q�)o?v�ԧ�/�S�NU��ls:�ܻ�A%ZH���6�4�RyKZ�d�A�[>~}����D�}�h�Q>;t�sȇũ�$)�����8�`���L<=����
��7���P�-�{嫄(�J�J��J�L�|�DF�s��7���g=��0D&�{��Ğ�{�|���3UL)�-��,S��2]L����;����B|wӶ��
�|�;�@�dy�'��n�� ����Y���6�ރB��y��Yc�����UK����7��u���2L�J�p�BW�m>{:�|���w��O�/�$�F2��N���A� Yj���||�eiS����z��`��Om:'�;,s񜔊aT-� �o�C@ZJ5(;f����΁�����&]�J(�i����K�LC�'�aY�]�߃��l�/|F�j�!A�
c�R�H����íHID I��Gh��G��5/n�O�����O���f��T�}�'�~[θ<�:��bp�b�w��6(n;%�T�
:����Fq`iY��q�t,�Y�ߤb�N�:�P�7�ԝ˄WP��x�|ɐ��C4�*=p�)-�/�8]�\�Hv�,B-S-";�].>�	���x�E��.��v��q[�4��?N#�Fd�h�!��a��<��f!���<���;�Ή9�s��^�6��$*�v!W⡮��3����>ߢ��o@ο�n����y0	D�}=�n�eB)�w0)m�O��*���ؤ�N�u N[���l-4�a�o��#`Hl�������6(���NJ�K�����|��g&l7�#�� ��EC���^���w�HO�E*v8W�g����·�Wr%S-�H�t�4,X)��^� ���o}=]h���gl����z#[��9�1ӟ}?4>�1~���A)
�>��P{$�?�I��9��T�G���u�m���Hj�N�p���'��RW{��?�ϵ�����ūd�K0�8�-*oy��O�����I����,� �������aU���uˑ����L�F�����D�CP�\����c��e��Iҗ�'6�LD����	r�Nү�"����k@W��ݾ$\dc�m��Z�S�_QA��<,%��Vt�~����_	��en����@��y̏�*9T�g���/�t2�F�u""����p��FT��HV��مO$V�T��g'�Vo]
65Z����M����`�z�F�A+�|�r��]
�5[�+�~�#��f���:�ɬf_��hdd��h6����ibB�Ճ��򗦳���ѵ�,�������5$�w�<��Lm��r��9��7Ʉ�=0a���4�����4C�K������<�+�����ǋ��'��=�n�N�S��,l6��������r�Ԋ��K}Uw���M��+�jq]9
����X�